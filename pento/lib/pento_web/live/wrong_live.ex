defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def handle_event("guess", %{"number" => guess} = data, socket) do
    IO.inspect data
    IO.inspect socket
    cond do
    #the score was not increasing even when the correct choice was made, since the user input is a string, and the choice is an integer. Hence, string.to_integer was used in the line above.
    String.to_integer(guess) == socket.assigns.choice -> 
      message = "Your guess is correct! You won!"
      {
      :ok,
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

    <h2>
      <%= @message %>
      It's <%= @time %>
    </h2>

    <h2>
      <%= for n <- 1..10 do%>
        <a href="#" phx-click="guess" phx-value-number={n} >
          <%= n %>
        </a>
      <% end %>
    </h2>
    
    """
  end

  def time() do
    DateTime.utc_now() |> to_string()
  end
end