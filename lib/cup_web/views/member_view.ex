defmodule CupWeb.MemberView do  # from controller thru view

  ##############################################################
  # Views are modules responsible for rendering.               #
  # Rendering functions that convert data to HTML or JSON      #
  # Or the rendering functions can be defined from templates   #
  # data can be rendered via                                   #
  # 1. raw template function                                   #
  # 2. am embedded Elixir engine                               #
  # 3. any other template engine                               #
  ##############################################################

  use CupWeb, :view  #set up a view module
  alias Cup.Accounts

  def first_name(%Accounts.Member{firstname: firstname}) do
    firstname
      |> String.split(" ")
      |> Enum.at(0)
  end

  def render("member.json", %{member: member}) do
    %{id: member.id, membername: member.membername}
  end

end
