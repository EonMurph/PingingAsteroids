const std = @import("std");

const rl = @import("raylib");

const Asteroid = @import("asteroid.zig").Asteroid;
const Ship = @import("ship.zig").Ship;
const window = @import("window.zig").window;

const State = struct {
    p1: *Ship,
    p2: *Ship,
    asteroid: *Asteroid,
    allocator: *const std.mem.Allocator,
};

fn update(state: *State, io: std.Io) void {
    if (rl.isKeyDown(.w)) {
        state.p1.up();
    } else if (rl.isKeyDown(.s)) {
        state.p1.down();
    } else if (rl.isKeyPressed(.space)) {
        // for testing asteroid shapes
        state.allocator.destroy(state.asteroid);
        state.asteroid.destroy();
        const ball: *Asteroid = state.allocator.create(Asteroid) catch unreachable;
        ball.* = Asteroid.init(io, state.allocator);
        state.asteroid = ball;
    }
    state.asteroid.*.move();
}

fn render(state: *const State) void {
    state.p1.draw();
    state.p2.draw();
    state.asteroid.draw();
}

pub fn main(init: std.process.Init) void {
    var dba = std.heap.DebugAllocator(.{}).init;
    defer std.debug.assert(dba.deinit() == .ok);
    const allocator = dba.allocator();

    const inset = 10;
    var p1 = Ship.init(inset);
    const p2_inset = inset + p1.width;
    var p2 = Ship.init(window.width - p2_inset);
    const ball: *Asteroid = allocator.create(Asteroid) catch unreachable;
    ball.* = Asteroid.init(init.io, &allocator);

    var state = State{
        .p1 = &p1,
        .p2 = &p2,
        .asteroid = ball,
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
