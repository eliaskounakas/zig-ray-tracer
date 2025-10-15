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

    pub fn add(self: Vec3, other: Vec3) Vec3 {
        return init(self.x + other.x, self.y + other.y, self.z + other.z);
    }

    pub fn sub(self: Vec3, other: Vec3) Vec3 {
        return init(self.x - other.x, self.y - other.y, self.z - other.z);
    }

 };

pub fn intersectsWithSphere(pos: Vec3, direction: Vec3, radius: f32) bool {
    const a = direction.dot(direction);
    const b = 2 * pos.dot(direction);
    const c = pos.dot(pos) - radius * radius;

    const expr_under_sqrt = b * b - 4 * a * c;
    if (expr_under_sqrt < 0) {
        return false;
    }
    const root = std.math.sqrt(expr_under_sqrt);
    
    const t1 = (-b + root) / (2 * a);
    const t2 = (-b - root) / (2 * a);


    return t1 >= 0 or t2 >= 0;
}

pub fn main() !void {
    const camera_pos = Vec3.init(0, 0, -150);
    const camera_direction = Vec3.init(0, 0, 1);
    const camera_up = Vec3.init(0, 1, 0);
    const camera_right = Vec3.init(1, 0, 0);
    const focal_length = 100;
    const screen_width = 1280;
    const screen_height = 960;

    const radius = 110;

    const middle_of_screen = camera_pos.add(camera_direction.scale(focal_length));

    var stdout_buffer: [4096]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("P3\n{d} {d}\n255\n", .{ @abs(screen_width), @abs(screen_height)});


    var y: f32 = (-screen_height) / 2;

    while (y < screen_height / 2): (y += 1) {
        var x: f32 = (-screen_width) / 2;
        while (x < screen_width / 2): (x += 1) {
            var point_on_screen: Vec3 = middle_of_screen;

            point_on_screen = point_on_screen.add(camera_right.scale(x));
            point_on_screen = point_on_screen.add(camera_up.scale(y));

            const ray_direction = point_on_screen.sub(camera_pos);

            const intersects = intersectsWithSphere(camera_pos, ray_direction, radius);

            if (intersects) {
                try stdout.print("255 255 255\n", .{});
            } else {
                try stdout.print("0 0 0\n", .{});
            }

            try stdout.print("\n", .{});
        }
    }
    try stdout.flush();
}
