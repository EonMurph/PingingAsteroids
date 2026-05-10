const std = @import("std");
const Io = std.Io;
const math = std.math;
const Random = std.Random;
const fmt = std.fmt;
const time = std.time;

const rl = @import("raylib");
const Vec2 = rl.Vector2;

const utils = @import("utils.zig");
const vecAdd = utils.vecAdd;
const vecRotate = utils.vecRotate;
const window = @import("window.zig").window;

pub const Ball = struct {
    bounding_r: f32,
    pos: Vec2,
    vel: Vec2,
    prng: Random.DefaultPrng,
    points: []Vec2,
    max_dist: f32,
    allocator: *const std.mem.Allocator,

    pub fn init(io: Io, allocator: *const std.mem.Allocator) Ball {
        const size_scalar = 100;

        var prng = Random.DefaultPrng.init(@intCast(Io.Clock.real.now(io).toMicroseconds()));
        const points, const max_dist = getPoints(allocator, &prng, size_scalar);

        return Ball{
            .bounding_r = size_scalar * max_dist,
            .pos = Vec2.init(window.width / 2, window.height / 2),
            .vel = Vec2.init(0, 10),
            .prng = prng,
            .points = points,
            .max_dist = max_dist,
            .allocator = allocator,
        };
    }

    pub fn move(self: *Ball) void {
        self.pos.y += self.vel.y;
        self.pos.x += self.vel.x;

        if (self.pos.y - self.bounding_r > window.height) {
            self.pos.y = self.pos.y - window.height;
        } else if (self.pos.y + self.bounding_r < 0) {
            self.pos.y = self.pos.y + window.height;
        }
    }

    fn getPoints(allocator: *const std.mem.Allocator, prng: *Random.DefaultPrng, size: f32) struct { []Vec2, f32 } {
        const n_points = prng.random().intRangeAtMost(u8, 10, 15);

        var angles = allocator.alloc(f32, n_points) catch unreachable;
        errdefer allocator.free(angles);
        defer allocator.free(angles);

        const min_angle: f32 = 0.3;
        for (0..n_points) |i| {
            angles[i] = prng.random().float(f32) * ((2 * math.pi) - (@as(f32, n_points) * min_angle));
        }
        std.mem.sortUnstable(f32, angles, {}, comptime std.sort.asc(f32));
        for (angles, 0..) |angle, i| {
            angles[i] = angle + (@as(f32, @floatFromInt(i)) * min_angle);
        }

        var points = allocator.alloc(Vec2, n_points) catch unreachable;
        errdefer allocator.free(points);

        const min_dist: f32 = 0.4;
        var max_dist: f32 = 0;
        for (0..n_points) |i| {
            var dist = prng.random().float(f32);
            if (prng.random().float(f32) > 0.2) {
                dist = (((1 - min_dist) * (dist - 0)) / (1 - 0)) + min_dist;
            }
            max_dist = if (dist > max_dist) dist else max_dist;
            const len = size * dist;
            points[i] = Vec2.init(len * math.cos(angles[i]), len * math.sin(angles[i]));
        }

        return .{ points, max_dist };
    }

    fn drawInstance(self: *const Ball, pos: Vec2) !void {
        var curPoint: Vec2 = undefined;
        var nextPoint: Vec2 = undefined;
        for (0..self.points.len) |i| {
            curPoint = vecAdd(self.points[i], pos);
            nextPoint = vecAdd(self.points[(i + 1) % self.points.len], pos);
            rl.drawLineEx(curPoint, nextPoint, 3, rl.Color.red.brightness(@as(f32, @floatFromInt(i)) / @as(f32, @floatFromInt(self.points.len))));
            // rl.drawLineEx(curPoint, nextPoint, 3, rl.Color.red);
        }
    }

    pub fn draw(self: *const Ball) void {
        const dir: f32 = switch (math.signbit(self.vel.y)) {
            true => 1,
            false => -1,
        };
        // rl.drawCircle(@intFromFloat(self.pos.x), @intFromFloat(self.pos.y + (dir * window.height)), self.r, .white);
        // rl.drawCircle(@intFromFloat(self.pos.x), @intFromFloat(self.pos.y), self.r, .white);
        self.drawInstance(self.pos) catch unreachable;
        self.drawInstance(.{
            .x = self.pos.x,
            .y = self.pos.y + (dir * window.height),
        }) catch unreachable;
    }

    pub fn destroy(self: *const Ball) void {
        self.allocator.free(self.points);
    }
};
