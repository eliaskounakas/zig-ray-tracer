const std = @import("std");
// const zig_ray_tracer = @import("zig_ray_tracer");
const Vec3 = struct { 
    x: f32,
    y: f32, 
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec3 {
            .x = x,
            .y = y,
            .z = z,
        };
    }

    pub fn dot(self: Vec3, other: Vec3) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    pub fn scale(self: Vec3, scalar: f32) Vec3 {
        return init(self.x * scalar, self.y * scalar, self.z * scalar);
    }
};


const cameraPos = Vec3.init(0, 0, -20);
const cameraUp = Vec3.init(0, 1, 0);
const cameraRight = Vec3.init(1, 0, 0);
const focalDistance = 10;
const screenWidth = 64;
const screenHeight = 48;

pub fn intersectsSphere(x: i64, y: i64) bool {
    // x^2 + y^2 = r^2;
    
    
}

pub fn main() !void {
    var x: i32 = -240;
    const x_end = -x;
    var y: i32 = -320;
    const y_end = -y;

    var stdout_buffer: [4096]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("P3\n{d} {d}\n255\n", .{ @abs(y) * 2, @abs(x) * 2 });

    while (x < x_end) : (x += 1) {
        y = -320;
        while (y < y_end) : (y += 1) {
            const is_inside: bool = intersectsSphere(x, y);
            if (is_inside) {
                try stdout.print("255 255 255\n", .{});
            } else {
                try stdout.print("0 0 0\n", .{});
            }
        }
        try stdout.print("\n", .{});
    }

    try stdout.flush();
}

