const std = @import("std");
// const zig_ray_tracer = @import("zig_ray_tracer");

pub fn isInCircle(x: i64, y: i64) bool {
    // x^2 + y^2 = r^2;
    const r: f16 = 80;
    const r_squared: i64 = @intFromFloat(r * r);
    return x * x + y * y <= r_squared;
}

pub fn main() !void {
    var x: i32 = -240;
    const x_end = -x;
    var y: i32 = -320;
    const y_end = -y;

    var stdout_buffer: [4096]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("P3\n{d} {d}\n255\n", .{@abs(y) * 2, @abs(x) * 2}); 

    while (x < x_end) : (x += 1) {
        y = -320;
        while (y < y_end) : (y +=1 ) {
            const is_inside: bool = isInCircle(x, y);
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

