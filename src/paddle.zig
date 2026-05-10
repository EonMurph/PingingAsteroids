const rl = @import("raylib");

const window = @import("window.zig").window;

pub const Paddle = struct {
    pos: rl.Vector2,
    vel_y: u8,
    width: u8,
    height: u8,

    pub fn init(x: f32) Paddle {
        return Paddle{
            .pos = rl.Vector2.init(x, 10),
            .vel_y = 8,
            .width = 15,
            .height = 100,
        };
    }

    pub fn up(self: *Paddle) void {
        self.pos.y = @max(self.pos.y - self.vel_y, 0);
    }

    pub fn down(self: *Paddle) void {
        self.pos.y = @min(self.pos.y + self.vel_y, window.height - self.height);
    }

    pub fn draw(self: *const Paddle) void {
        rl.drawRectangle(@intFromFloat(self.pos.x), @intFromFloat(self.pos.y), self.width, self.height, .white);
    }
};
