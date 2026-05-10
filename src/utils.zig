const math = @import("std").math;
const Vec2 = @import("raylib").Vector2;


pub fn vecAdd(v1: Vec2, v2: Vec2) Vec2 {
    return Vec2.init(v1.x + v2.x, v1.y + v2.y);
}

pub fn vecRotate(r: f32, a: f32) Vec2 {
    const x = r * math.cos(a);
    const y = r * math.sin(a);

    return Vec2.init(x, y);
}
