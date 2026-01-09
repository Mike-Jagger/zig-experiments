const std = @import("std");

pub fn main() void {
    const user = User{
        .power = 6769,
        .name = "Goku",
    };

    std.debug.print("{s}'s power is {d}\n", .{ user.name, user.power });
}

const User = struct {
    name: []const u8,
    power: u64,
};
