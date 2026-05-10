const std = @import("std");
const rl = @import("raylib");
const window = @import("window.zig").window;
const Paddle = @import("paddle.zig").Paddle;
const Ball = @import("ball.zig").Ball;

const State = struct {
    p1: *Paddle,
    p2: *Paddle,
    ball: *Ball,
    allocator: *const std.mem.Allocator,
};

fn update(state: *State, io: std.Io) void {
    if (rl.isKeyDown(.w)) {
        state.p1.up();
    } else if (rl.isKeyDown(.s)) {
        state.p1.down();
    } else if (rl.isKeyPressed(.space)) {
        // for testing asteroid shapes
        state.allocator.destroy(state.ball);
        state.ball.destroy();
        const ball: *Ball = state.allocator.create(Ball) catch unreachable;
        ball.* = Ball.init(io, state.allocator);
        state.ball = ball;
    }
    state.ball.*.move();
}

fn render(state: *const State) void {
    state.p1.draw();
    state.p2.draw();
    state.ball.draw();
}

pub fn main(init: std.process.Init) void {
    var dba = std.heap.DebugAllocator(.{}).init;
    defer std.debug.assert(dba.deinit() == .ok);
    const allocator = dba.allocator();

    const inset = 10;
    var p1 = Paddle.init(inset);
    const p2_inset = inset + p1.width;
    var p2 = Paddle.init(window.width - p2_inset);
    const ball: *Ball = allocator.create(Ball) catch unreachable;
    ball.* = Ball.init(init.io, &allocator);

    var state = State{
        .p1 = &p1,
        .p2 = &p2,
        .ball = ball,
        .allocator = &allocator,
    };

    rl.initWindow(window.width, window.height, "Pong");
    defer rl.closeWindow();

    rl.setExitKey(rl.KeyboardKey.q);
    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        update(&state, init.io);

        rl.beginDrawing();
        defer rl.endDrawing();

        render(&state);

        rl.clearBackground(.black);
    }
}
