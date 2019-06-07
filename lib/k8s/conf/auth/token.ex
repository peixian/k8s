defmodule K8s.Conf.Auth.Token do
  @moduledoc """
  Token based cluster authentication
  """

  @behaviour K8s.Conf.Auth

  @derive {Inspect, only: []}
  defstruct [:token]
  @type t :: %__MODULE__{token: binary}

  @impl true
  @spec create(map() | any, String.t() | any) :: K8s.Conf.Auth.Token.t() | nil
  def create(%{"token" => token}, _), do: %K8s.Conf.Auth.Token{token: token}
  def create(_, _), do: nil

  defimpl K8s.Conf.RequestOptions, for: __MODULE__ do
    @doc "Generates HTTP Authorization options for certificate authentication"
    @spec generate(K8s.Conf.Auth.Token.t()) :: K8s.Conf.RequestOptions.generate_t()
    def generate(%K8s.Conf.Auth.Token{token: token}) do
      {:ok,
       %K8s.Conf.RequestOptions{
         headers: [{"Authorization", "Bearer #{token}"}],
         ssl_options: []
       }}
    end
  end
end
