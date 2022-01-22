LATEST = 'latest'
SPORTS = 'sports'
CORONA = 'corona'
WORLD = 'world'
EDUCATION = 'education'
BUSINESS = 'business'
GAMING = 'gaming'
TRENDING = 'trending'
FASHION = 'fashion'
AUTOMOBILE = 'automobile'
TECHNOLOGY ='technology'
NEWS_HOME_PAGE_URL = "https://www.indiatoday.in"
NEWS_URL = {
    LATEST: "https://www.indiatoday.in/top-stories",
    SPORTS: "https://www.indiatoday.in/sports",
    CORONA: "https://www.indiatoday.in/coronavirus-covid-19-outbreak",
    WORLD: "https://www.indiatoday.in/world",
    EDUCATION: "https://www.indiatoday.in/education-today/news",
    BUSINESS: "https://www.indiatoday.in/business",
    GAMING: "https://www.gamesradar.com/news/",
    TRENDING: "https://www.indiatoday.in/trending-news",
    FASHION: "https://www.indiatoday.in/lifestyle/fashion",
    AUTOMOBILE: "https://www.indiatoday.in/auto/latest-auto-news",
    TECHNOLOGY: "https://www.indiatoday.in/technology/news"
}

BATCH_TO_NEWS_MAPPING = {
    'batch_1': [LATEST],
    'batch_2': [SPORTS, TECHNOLOGY, CORONA, WORLD, EDUCATION],
    'batch_3': [BUSINESS, GAMING, FASHION, AUTOMOBILE, TRENDING]
}

BACTH_1_NEWS_LIST = [LATEST]
BATCH_2_NEWS_LIST = [SPORTS, TECHNOLOGY, CORONA, WORLD, EDUCATION]
BATCH_3_NEWS_LIST = [BUSINESS, GAMING, FASHION, AUTOMOBILE, TRENDING]

BATCH_REHIT_TIME = {
    'batch_1': 1,
    'batch_2': 3,
    'batch_3': 4
}