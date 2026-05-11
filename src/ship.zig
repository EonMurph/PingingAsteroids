const std = @import("std");

const rl = @import("raylib");
const Vec2 = rl.Vector2;

const vecAdd = @import("utils.zig").vecAdd;
const window = @import("window.zig").window;

const Projectile = struct {
    vel: Vec2,
    dir: Vec2,
    pos: Vec2,

    pub fn init(vel: f32, dir: Vec2, pos: Vec2) Projectile {
        return Projectile{
            // TODO: fix projectile velocity to account for direction
            .vel = Vec2.init(vel, 0),
            .dir = dir,
            .pos = pos,
        };
    }

    pub fn draw(self: *const Projectile) void {
        rl.drawLineEx(self.pos, vecAdd(self.pos, self.dir), 3, .white);
    }

    pub fn update(self: *Projectile) void {
        self.pos = vecAdd(self.pos, self.vel);
    }
};

pub const Ship = struct {
    pos: rl.Vector2,
    vel_y: u8,
    width: u8,
    height: u8,
    projectiles: std.ArrayList(Projectile),
    allocator: std.mem.Allocator,

    pub fn init(x: f32, allocator: std.mem.Allocator) Ship {
        const height = 100;

        return Ship{
            .pos = rl.Vector2.init(x, (window.height / 2) - (height / 2)),
            .vel_y = 8,
            .width = 15,
            .height = height,
            .projectiles = std.ArrayList(Projectile).initCapacity(allocator, 10) catch unreachable,
            .allocator = allocator,
        };
    }

    pub fn up(self: *Ship) void {
        self.pos.y = @max(self.pos.y - self.vel_y, 0);
    }

    pub fn down(self: *Ship) void {
        self.pos.y = @min(self.pos.y + self.vel_y, window.height - self.height);
    }

    pub fn updateProjectiles(self: *Ship) void {
        var i: usize = self.projectiles.items.len;
        while (self.projectiles.items.len > 0 and i > 0) : (i -|= 1) {
            self.projectiles.items[i-1].update();
            const pos = self.projectiles.items[i-1].pos;
            if (pos.x > window.width or pos.x < 0 or pos.y > window.height or pos.y < 0) {
                _ = self.projectiles.swapRemove(i-1);
            }
        }
    }

    pub fn draw(self: *const Ship) void {
        rl.drawRectangle(@intFromFloat(self.pos.x), @intFromFloat(self.pos.y), self.width, self.height, .white);
        for (self.projectiles.items) |*projectile| {
            projectile.draw();
        }
    }

    pub fn shoot(self: *Ship) void {
        self.projectiles.append(self.allocator, Projectile.init(3, Vec2.init(10, 0), self.pos)) catch unreachable;
    }
};
