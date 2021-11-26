defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def handle_event("guess", %{"number" => guess} = data, socket) do
    IO.inspect data
    IO.inspect socket
    cond do
    #the score was not increasing even when the correct choice was made, since the user input is a string, and the choice is an integer. Hence, string.to_integer was used in the line below.
    String.to_integer(guess) == socket.assigns.choice -> 
      message = "Your guess is correct!"
      {
      :noreply,
      assign(
        socket,
        choice: Enum.random(1..10),
        score: socket.assigns.score + 1,
        message: message,
        time: time()
      )
    }
    true -> message = "Your guess is: #{guess}. Guess again."
          {
            :noreply, 
            assign(
              socket,
              choice: socket.assigns.choice,
              message: message,
              score: socket.assigns.score - 1,
              time: time()
            )
          }
    end
  end

  def handle_params(_params, _, socket) do
    {:noreply, 
    assign(
        socket,
        choice: Enum.random(1..10),
        score: 0,
        message: "Guess a number.",
        time: time()
      )
    }
  end

  #so this handle_event clause was not required. To restart the game upon winning, include live_patch directly in the render and a handle_params function is required, as live_patch invokes handle_params (ref: https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Helpers.html#live_patch/2)
  #handle_params must return {:noreply, socket}. since we want to reset the socket state to start the game again, the assigns for score, choice and message are set for socket again. So basically, handle_params/3 looks like a duplicate of mount/3 in this case. (this is correct as per Jose's comment in this thread https://elixirforum.com/t/mount-vs-handle-params-on-the-liveview-life-cycle/31920/3)
  #def handle_event("restart", _, socket) do
    #{:noreply, 
    #push_patch(
    #  socket, 
    #  to: "/guess", 
    #  replace: true
    #  )
    #}
    #live_patch to: Routes.live_path(socket, WrongLive, dir: :asc), replace: true

  #  {:noreply,
  #  live_patch(
  #    to: Routes.live_path(
  #      socket, PentoWeb.WrongLive
  #      ),
  #    replace: true
  #    )
  #  }
  #end

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        choice: Enum.random(1..10),
        score: 0,
        message: "Guess a number.",
        time: time()
      )
    }
  end

  def render(assigns) do
    #The book uses the ~L sigil on page 20 for rendering in LEEx, however, this app uses phoenix 1.6 which uses HEEx, hence the ~H sigil has been used
    ~H"""
    <h1>
      Your score: <%= @score %>
    </h1>
      <%= if @score >= 5 do %>
        <div>
        <h2>
        You won!
        </h2>
        
        <%= live_patch to: Routes.live_path(@socket, PentoWeb.WrongLive), replace: true do %>
          <button type="button">Start again</button>
        <% end %>
        
        </div>
      <% else %>
        <h2>
          <%= @message %>
          It's <%= @time %>
          The choice is <%= @choice %>
        </h2>

        <h2>
          <%= for n <- 1..10 do%>
            <a href="#" phx-click="guess" phx-value-number={n} >
              <%= n %>
            </a>
          <% end %>
        </h2>
      <% end %>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string()
  end
end