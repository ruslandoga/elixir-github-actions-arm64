defmodule ATest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest A

  test "greets the world" do
    assert A.hello() == :world
  end

  @endpoint Web.Endpoint
  @endpoint_opts @endpoint.init([])

  test "greets the world over http" do
    conn = conn(:get, "/")
    conn = @endpoint.call(conn, @endpoint_opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello, world!"
  end
end
