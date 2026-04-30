const rl = @import("raylib");
const w = @import("window.zig");

pub fn main() anyerror!void {
    rl.initWindow(w.window.width, w.window.height, "Pong");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);
    }
}
