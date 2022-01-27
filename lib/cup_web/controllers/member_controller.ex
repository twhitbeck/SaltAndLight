defmodule CupWeb.MemberController do

  use CupWeb, :controller         # :controller API

  alias Cup.Accounts
  alias Cup.Accounts.Member

  # member must authenticate to access index or show page
  plug :authenticate_member when action in [:index, :show]

  alias CupWeb.Router.Helpers, as: Routes

  # note about render - rendering functions can exist in:
  # 1. view - responsible for rendering
  # 2. template - web page or page fragment

  # render(conn, template, assigns)
  # render(
  #   Plug.Conn.t(),
  #   binary() | atom(),
  #   Keyword.t() | map() | binary() | atom()
  #   ) :: Plug.Conn.t()


  def new(conn, _params) do
    changeset = Accounts.change_registration(%Member{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def index(conn, _params) do
    members = Accounts.list_members()  #fails
    render(conn, "index.html", members: members)
  end

  def show(conn, %{"id" => id}) do
    member = Accounts.get_member(id)
    render(conn, "show.html", member: member)
  end

  ############################################
  # Starts with an empty member              #
  # Pick off the member params               #
  # applies a changeset - Accounts.create    #
  # pass them to Accounts.register_member fn #
  # inserts it into the repository           #
  # show VALIDATION errors upon failure      #
  ############################################
  def create(conn, %{"member" => member_params}) do        #action for create
    case Accounts.register_member(member_params) do        # case 1 - OK
      {:ok, member} ->
        conn
        |> CupWeb.Auth.login(member)
        |> put_flash(:info, "#{member.name} created!")
        |> redirect(to: Routes.member_path(conn, :index)) # case 2 - error

    {:error, %Ecto.Changeset{} = changeset} ->
       render(conn, "new.html", changeset: changeset)   # re-render new.html
    end  # {:ok
  end      # create

  # if there is a current member - return connection unchanged
  # otherwise redirect back to application root
  # use halt(conn) to stop any downstream transformations

  # defp authenticate(conn, _opts) do  # a function plug
 #   if conn.assigns.current_member do
 #     conn
 #   else
 #     conn
 #     |> put_flash(:error, "You must be logged in to access that page")
 #     |> redirect(to: Routes.page_path(conn, :index))
 #     |> halt()
 #   end
 # end

end
