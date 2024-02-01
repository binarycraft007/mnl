const std = @import("std");
const testing = std.testing;
pub const c = @cImport(@cInclude("libmnl/libmnl.h"));

test {
    const nl_maybe = c.mnl_socket_open(c.NETLINK_ROUTE);
    if (nl_maybe) |nl| {
        defer _ = c.mnl_socket_close(nl);
    }
}
