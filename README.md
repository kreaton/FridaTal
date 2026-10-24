# FridaTal

A small number game for kids. A number between 2 and 19 is shown, and the child
clicks the number just **before** and the number just **after** it on a grid of
1–20. A cheerful sound plays when both are right, and an "uh-oh" sound when the
two picks are wrong. **Næste ➜** (Next) starts a new round.

Built with Blazor WebAssembly on .NET 10, so it runs entirely in the browser and
can be installed to an iPad/phone home screen as a PWA.

## Requirements

- .NET 10 SDK (`dotnet --list-sdks` should list a `10.0.x` version)
- A trusted HTTPS dev certificate for the https URL:

  ```bash
  dotnet dev-certs https --trust
  ```

## Run it

From the solution folder, either double-click `Run.bat` or run:

```bash
dotnet run --project FridaTal
```

Then open <http://localhost:5161> (or <https://localhost:7161>).

Plain `dotnet run` in the solution folder does not work, because the project
lives in the `FridaTal` subfolder. Either pass `--project` or `cd FridaTal` first.

In Visual Studio, open `FridaTal.slnx` and press F5; the `FridaTal` launch profile
opens the browser automatically.

## Publish

`FridaTal\Publish.bat` runs:

```bash
dotnet publish -c Release -o bin/publish
```

The static site ends up in `FridaTal\bin\publish\wwwroot`. Copy that folder to
any static web host. If it is not hosted at the site root, change
`<base href="/" />` in `wwwroot/index.html` to the sub-path (for example
`<base href="/fridatal/" />`).

## Project layout

| Path | What it is |
| --- | --- |
| `FridaTal/Pages/Home.razor` | The whole game: picking the number, the grid and checking answers |
| `FridaTal/wwwroot/css/app.css` | All styling, including the landscape (iPad) layout |
| `FridaTal/wwwroot/js/sounds.js` | Success and error sounds, synthesized with the Web Audio API (no audio files) |
| `FridaTal/wwwroot/index.html` | Host page, icons and PWA meta tags |
| `FridaTal/wwwroot/manifest.webmanifest` | PWA manifest for "Add to Home Screen" |

## Changing the game

- **Number range:** `Min` and `Max` in `Home.razor`. The grid has 5 columns, and
  the landscape layout assumes 4 rows (`grid-template-rows` in `app.css`).
- **Sounds:** edit the notes in `sounds.js`. Browsers only allow sound after the
  first tap, which the game always has before a sound plays.
