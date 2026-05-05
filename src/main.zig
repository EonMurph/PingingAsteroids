const rl = @import("raylib");
const window = @import("window.zig").window;
const Paddle = @import("paddle.zig").Paddle;

const State = struct {
    p1: *Paddle,
    p2: *Paddle,
};

fn update(p1: *Paddle, p2: *Paddle) void {
    _ = p2;
    if (rl.isKeyDown(.w)) {
        p1.up();
    } else if (rl.isKeyDown(.s)) {
        p1.down(window);
    }
}

fn render(state: *State) void {
    state.p1.draw();
    state.p2.draw();
}

pub fn main() void {
    var state: State = undefined;

    var p1 = Paddle.init(10);
    var p2 = Paddle.init(window.width - @as(u32, 10 + p1.width));

    state = State{
        .p1 = p1,
        .p2 = p2,
    };
    rl.initWindow(window.width, window.height, "Pong");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        update(&p1, &p2);

        rl.beginDrawing();
        defer rl.endDrawing();

        render(&p1, &p2);

        rl.clearBackground(.black);
    }
}
