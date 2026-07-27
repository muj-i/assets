# assets

Static assets for [muj-i.github.io](https://muj-i.github.io) and the
[muj-i](https://github.com/muj-i/muj-i) profile README.

Consolidated here from `muj-i/muj-i` and `muj-i/mocks` so every image has one
home and one URL scheme.

## Layout

| Folder          | Contents                                     |
| --------------- | -------------------------------------------- |
| `icons/`        | Tech-stack and social SVG icons               |
| `profile/`      | Profile photos and README gifs                |
| `docs/`         | Résumés                                       |
| `certificates/` | Certificates and assessments                  |
| `projects/`     | Personal project mockups                      |
| `companies/`    | Company project mockups, one folder per org   |

## Usage

Served over the jsDelivr CDN:

```
https://cdn.jsdelivr.net/gh/muj-i/assets@main/<folder>/<file>
```

Filenames are lowercase and hyphenated. Uploads from the portfolio admin panel
land here automatically, and replaced images are deleted in the same pass.
