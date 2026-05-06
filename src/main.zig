const rl = @import("raylib");
const window = @import("window.zig").window;
const Paddle = @import("paddle.zig").Paddle;
const Ball = @import("ball.zig").Ball;

const State = struct {
    p1: *Paddle,
    p2: *Paddle,
    ball: *Ball,
};

fn update(state: *const State) void {
    if (rl.isKeyDown(.w)) {
        state.p1.up();
    } else if (rl.isKeyDown(.s)) {
        state.p1.down();
    }
    state.ball.move();
}

fn render(state: *const State) void {
    state.p1.draw();
    state.p2.draw();
    state.ball.draw();
}

pub fn main() void {
    var p1 = Paddle.init(10);
    const p2_inset = 10 + p1.width;
    var p2 = Paddle.init(window.width - p2_inset);
    var ball = Ball.init(50);

    var state = State{
        .p1 = &p1,
        .p2 = &p2,
        .ball = &ball,
    };
    rl.initWindow(window.width, window.height, "Pong");
    defer rl.closeWindow();

    rl.setExitKey(rl.KeyboardKey.q);
    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        update(&state);

        rl.beginDrawing();
        defer rl.endDrawing();

        render(&state);

        rl.clearBackground(.black);
    }
}
