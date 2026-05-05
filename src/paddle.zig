const rl = @import("raylib");
const Window = @import("window.zig").Window;

pub const Paddle = struct {
    pos: rl.Vector2,
    vel_y: u8,
    width: u8,
    height: u8,

    pub fn init(x: u32) Paddle {
        return Paddle{
            .pos = rl.Vector2.init(x, 10),
            .vel_y = 8,
            .width = 15,
            .height = 100,
        };
    }

    pub fn up(self: *Paddle) void {
        self.pos.y -|= self.vel_y;
    }

    pub fn down(self: *Paddle, window: Window) void {
        self.pos.y = @min(self.pos.y + self.vel_y, window.height - self.height);
    }

    pub fn draw(self: Paddle) void {
        rl.drawRectangle(@intCast(self.pos.x), @intCast(self.pos.y), self.width, self.height, .white);
    }
};
