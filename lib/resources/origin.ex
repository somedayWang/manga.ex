defmodule Manga.Res.Origin do
  @callback search(String.t()) :: {:ok, [Manga.Res.Info.t()]} | {:error, String.t()}
  @callback stages(Manga.Res.Info.t()) :: {:ok, [Manga.Res.Stage.t()]} | {:error, String.t()}
  @callback fetch(Manga.Res.Stage.t()) :: {:ok, [Manga.Res.Page.t()]} | {:error, String.t()}

  @spec fetchall(Manga.Res.Origin, Manga.Res.Info.t()) ::
          {:ok, [Manga.Res.Stage.t()]} | {:error, String.t()}
  def fetchall(implementation, manga_info) do
    case implementation.stages(manga_info) do
      {:ok, list} ->
        list =
          Enum.map(list, fn stage ->
            {:ok, r} = implementation.fetch(stage)
            stage = %{stage | plist: r}
          end)

        {:ok, list}

      {:error, error} ->
        {:error, error}
    end
  end
end
