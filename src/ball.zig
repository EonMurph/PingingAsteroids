const std = @import("std");
const math = std.math;
const Random = std.Random;
const fmt = std.fmt;
const window = @import("window.zig").window;
const rl = @import("raylib");
const vec2 = rl.Vector2;

pub const Ball = struct {
    r: f32,
    pos: vec2,
    vel: vec2,

    pub fn init(r: f32) Ball {
        return Ball{
            .r = r,
            .pos = vec2.init(window.width / 2, window.height / 2),
            .vel = vec2.init(0, 10),
        };
    }

    pub fn move(self: *Ball) void {
        self.pos.y += self.vel.y;
        self.pos.x += self.vel.x;

        if (self.pos.y - self.r > window.height) {
            self.pos.y = self.pos.y - window.height;
        } else if (self.pos.y + self.r < 0) {
            self.pos.y = self.pos.y + window.height;
        }
    }

    fn draw_instance(self: *const Ball) !void {
        _ = self;
        // get n points
        // for each point pick distance and angle from prev
        var prng = Random.DefaultPrng.init(undefined);
        const rng = prng.random();

        const n_points = rng.intRangeLessThan(u8, 1, 6);
        _ = n_points;
    }

    pub fn draw(self: *const Ball) void {
        const dir: f32 = switch (math.signbit(self.vel.y)) {
            true => 1,
            false => -1,
        };
        rl.drawCircle(@intFromFloat(self.pos.x), @intFromFloat(self.pos.y + (dir * window.height)), self.r, .white);
        rl.drawCircle(@intFromFloat(self.pos.x), @intFromFloat(self.pos.y), self.r, .white);
        self.draw_instance();
    }
};
