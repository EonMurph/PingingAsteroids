const rl = @import("raylib");

const window = @import("window.zig").window;

pub const Ship = struct {
    pos: rl.Vector2,
    vel_y: u8,
    width: u8,
    height: u8,

    pub fn init(x: f32) Ship {
        const height = 100;

        return Ship{
            .pos = rl.Vector2.init(x, (window.height / 2) - (height / 2)),
            .vel_y = 8,
            .width = 15,
            .height = height,
        };
    }

    pub fn up(self: *Ship) void {
        self.pos.y = @max(self.pos.y - self.vel_y, 0);
    }

    pub fn down(self: *Ship) void {
        self.pos.y = @min(self.pos.y + self.vel_y, window.height - self.height);
    }

    pub fn draw(self: *const Ship) void {
        rl.drawRectangle(@intFromFloat(self.pos.x), @intFromFloat(self.pos.y), self.width, self.height, .white);
    }
};
