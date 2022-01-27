defmodule CupWeb.SessionController do
  use CupWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(
    conn,
    %{"session" => %{"membername" => membername, "password" => pass}}
  ) do
    case Cup.Accounts.authenticate_by_member_and_pass(membername, pass) do
      {:ok, member} ->
        conn
        |> CupWeb.Auth.login(member)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> CupWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end

end
