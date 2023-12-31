# type: ignore
import zipfile

import pandas as pd
import requests

import legal_instruments.extract as parser


def _scrape(url, item_type):
    if not url.startswith("http"):
        url = f"http://portal.unesco.org/en/{url}"

    response = requests.get(url, timeout=30)

    if response.status_code != 200:
        raise Exception(f"error: {url} {response.status_code}")  # pylint: disable=broad-exception-raised

    return (response.content, response.url, item_type)


def _to_df(items):
    return pd.DataFrame(
        [(x.section_id, x.unesco_id, x.filename, x.type, x.href, x.date.year, x.date, x.city, x.title) for x in items],
        columns=['section_id', 'unesco_id', 'filename', 'type', 'href', 'year', 'date', 'city', 'x.title'],
    )


def extract_pages(urls):
    for url, item_type in urls:
        yield _scrape(url, item_type)


def extract_items(pages, *extra_items):
    for item in extra_items:
        yield item

    for page, _, item_type in pages:
        for item in parser.extract_items(page, item_type):
            yield item


def extract_text(items):
    for item in items:
        (page, _, _) = _scrape(item.href, item.type)
        yield (item, parser.extract_text(page))


def progress(items):
    for item, text in items:
        print(f"downloaded: {item.filename}, {len(text)} bytes")
        yield (item, text)


def store_text(data, filename):
    with zipfile.ZipFile(filename, "w") as zf:
        for item, text in data:
            zf.writestr(item.filename, text, zipfile.ZIP_DEFLATED)

            yield item


def store_index(items, filename):
    df = _to_df(items)
    df.to_csv(filename, index=False, sep='\t')
    return df
