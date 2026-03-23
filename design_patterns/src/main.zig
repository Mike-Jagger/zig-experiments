const std = @import("std");
const root = @import("root.zig");

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    std.debug.print("Run `zig build tests` to see the design patterns at work", .{});
    try root.bufferedPrint();
}

test "Test Chain of Responsibility" {
    const ok = Button.init(.init());

    ok.componentWithContextualHelp.showtoolTip();
}

const ComponentWithContextualHelp = struct {
    ptr: *anyopaque,
    showToolTipFunc: *const fn (self: *anyopaque) anyerror!void,

    const Self = @This();

    fn init(ptr: anytype) Self {
        const T = @TypeOf(ptr);
        const ptr_info = @typeInfo(T);

        const gen = struct {
            pub fn showtoolTip(pointer: *anyopaque) anyerror!void {
                const self: T = @ptrCast(@alignCast(pointer));
                ptr_info.pointer.child.showToolTip(self);
            }
        };

        return .{
            .ptr = ptr,
            .showToolTipFunc = gen.showToolTip,
        };
    }

    fn showToolTip(self: Self) !void {
        self.showToolTipFunc(self.ptr);
    }
};

const Component = struct {
    container: ?*Container,
    tooltipText: ?[]u8,

    fn init(container: ?Container, tooltipText: ?[]u8) Component {
        return .{
            .container = container orelse undefined,
            .tooltipText = tooltipText orelse undefined,
        };
    }

    fn componentWithContextualHelp(self: *Component) ComponentWithContextualHelp {
        return switch (self.tooltipText) {
            null => .init(self),
            else => {
                std.debug.print("Tooltip text: {s}", .{self.tooltipText});
            },
        };
    }
};

const Container = struct {
    _last: u8,
    children: [256]Component,

    base: Component,

    fn init(children: ?[256]Component) Container {
        return .{
            ._last = -1,
            .children = children orelse undefined,

            .base = .init(),
        };
    }

    fn add(self: *Container, child: Component) !void {
        self._last.* +| 1;

        self.children[self._last] = child;

        child.container = @This();
    }

    fn componentWithContextualHelp(self: *Container) ComponentWithContextualHelp {
        return self.base.componentWithContextualHelp();
    }
};

const Button: type = struct {
    base: *Component,

    fn init(component: ?Component) Button {
        return .{
            .base = &component orelse &.init(),
        };
    }

    fn componentWithContextualHelp(self: *Button) ComponentWithContextualHelp {
        return self.base.componentWithContextualHelp();
    }
};

const Panel: type = struct {
    modalHelpText: []u8,

    base: Container,

    fn init(modalHelpText: ?[]u8, container: ?Container) Panel {
        return .{
            .modalHelpText = modalHelpText orelse undefined,
            .base = container orelse .init(),
        };
    }

    fn add(self: *Panel, child: Component) !void {
        self.base.add(child);
    }

    fn componentWithContextualHelp(self: *Panel) ComponentWithContextualHelp {
        return switch (self.modalHelpText) {
            null => self.base.componentWithContextualHelp(),
            else => std.debug.print("Modal help text: {s}", .{self.modalHelpText}),
        };
    }
};

const Dialog: type = struct {
    wikiURL: []u8,

    base: Container,

    fn init(wikiURL: ?[]u8, container: ?Container) Panel {
        return .{
            .wikiURL = wikiURL orelse undefined,
            .base = container orelse .init(),
        };
    }

    fn add(self: *Panel, child: Component) !void {
        self.base.add(child);
    }

    fn componentWithContextualHelp(self: *Panel) ComponentWithContextualHelp {
        return switch (self.wikiURL) {
            null => self.base.componentWithContextualHelp(),
            else => std.debug.print("Wikipedia URL: {s}", .{self.wikiURL}),
        };
    }
};
