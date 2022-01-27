defmodule CupWeb.Auth do  # a module plug
  import Plug.Conn
  import Phoenix.Controller
  alias  CupWeb.Router.Helpers, as: Routes

  def init(opts), do: opts  # necessary to accept compile time options

  ###########################################################################
  # Check if a :member_id is stored in the session                            #
  # If so - look up the :member_id and assign the result in the connection    #
  # assign is a Plug.conn function that slightly transforms the connection  #
  # In this case - stores either :member_id or nil in conn.assigns            #
  # So - :current_member will be available in controllers & views for example #
  ###########################################################################
  def call(conn, _opts) do   # check if :member_id is stored in the session
    member_id = get_session(conn, :member_id)

    cond do
      member = conn.assigns[:current_member] ->
        put_current_member(conn, member)

        member = member_id && Cup.Accounts.get_member(member_id) ->
          assign(conn, :current_member, member) # member exists, store in conn

      true ->
        assign(conn, :current_member, nil)   # store nil in conn

    end        # :current_member will be available downstream
  end          # transform conn - add :current_member to conn:assigns
               # downstream plugs can use conn.assigns to find if a member is logged in.


  # input conn and member - store member_id in the session
  def login(conn, member) do
    conn
    |> assign(:current_member, member)
    |> put_session(:member_id, member.id)
    |> configure_session(renew: true) #send different session cookie back to client
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_member(conn, _opts) do
    if conn.assigns.current_member do  # set by Plug.conn
      conn
    else
      conn
        |> put_flash(:error, "You must be logged in to access that page")
        |> redirect(to: Routes.page_path(conn, :index))
        |> halt()
    end
  end

  defp put_current_member(conn, member) do
    token = Phoenix.Token.sign(conn, "member socket", member.id)
       conn
       |> assign(:current_member, member)
       |> assign(:member_token, token)
  end

end
