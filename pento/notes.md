## Exercise on page 27 of the book (pg 44 of pdf): to use live_patch to re-render current LiveView with a socket state reset
  To restart the game upon winning, include live_patch directly in the render and a handle_params function is required, as live_patch invokes handle_params (ref: https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Helpers.html#live_patch/2)
  
  handle_params must return {:noreply, socket}. Since we want to reset the socket state to start the game again, the assigns for score, choice and message are set for socket again. So basically, handle_params/3 looks like a duplicate of mount/3 in this case. (this is correct as per Jose's comment in this thread https://elixirforum.com/t/mount-vs-handle-params-on-the-liveview-life-cycle/31920/3)

  Note: Routes.live_path/2 requires LiveView name as `PentoWeb.WrongLive` not `WrongLive`

  Note: Not using the `do` `end` format for live_patch throws errors