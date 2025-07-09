import os
import sys
import requests


def _get(url, cache):
    return url


# def _giphy(query, cache):
#     url = requests.get(
#         "https://api.giphy.com/v1/gifs/" + ("search" if query else "trending"),
#         params={
#             # I found this key on the internets and don't care about it
#             "api_key": os.getenv("GIPHY_API_KEY", "VtFOP3GgfrPo3KPWfjw0U5g8aD6VtIHi"),
#             "q": query,
#             "limit": 1,
#             "lang": "en",
#         },
#     ).json()["data"][0]["images"]["downsized"]["url"]
#     return _get(url, cache)


def _tenor(query, cache):
    url = requests.get(
        "https://g.tenor.com/v1/" + ("search" if query else "trending"),
        params={
            # I found this key on the internets and don't care about it
            "key": os.getenv("TENOR_API_KEY", "TQ7VXFHXBJQ5"),
            "q": query,
            "locale": "en_US",
            "limit": 1,
        },
    ).json()["results"][0]["media"][0]["tinygif"]["url"]
    return _get(url, cache)


def main():
    if len(sys.argv) != 2:
        print("Usage: python gif.py <search_term>")
        sys.exit(1)

    search_term = sys.argv[1]
    result_url = _tenor(search_term, None)
    print(result_url)


if __name__ == "__main__":
    main()
