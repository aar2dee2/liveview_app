defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def handle_event("guess", %{"number" => guess} = data, socket) do
    IO.inspect data
    message = "Your guess is: #{guess}. Guess again."
    score = socket.assigns.score - 1
    {
      :noreply, 
      assign(
        socket,
        message: message,
        score: score
      )
    }
  end

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Guess a number."
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
end