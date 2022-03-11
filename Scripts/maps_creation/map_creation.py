import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt
import shapely
import shapely.geometry as geom
import geopandas
import plotly.express as px

df = pd.read_csv("2008.csv")

df_air = pd.read_csv("airports.csv")
# Origin, Dest

# add suffix origin, and dest and join
df = df.merge(right=df_air.add_suffix("_origin"), left_on="Origin", right_on="iata_origin")
df = df.merge(right=df_air.add_suffix("_dest"), left_on="Dest", right_on="iata_dest")

# create geometry line connect 2 points origin and destination
# geometry is a shepely object
df['geometry'] = df.apply(
    lambda x: geom.LineString([(x['long_origin'], x['lat_origin']), (x['long_dest'], x['lat_dest'])]), axis=1)
gdf = geopandas.GeoDataFrame(df, geometry=df['geometry'])

# Working good

# download map of uS
states = geopandas.read_file('cb_2018_us_state_500k.shp')

# create geopandas dataframe with airports (necessary to plot airports)
gdf_air = geopandas.GeoDataFrame(df_air, geometry=geopandas.points_from_xy(df_air['long'], df_air['lat']))
gdf_air = gdf_air[gdf_air.iata.isin(gdf.Origin.unique())]
def plot_(df, alpha, lw=1, USA=True):
    # plot states
    axis = states.plot(color='lightblue', edgecolor='black')
    # plot airports
    gdf_air.plot(ax=axis, color="red", markersize=4)
    # plot flights
    df.plot(ax=axis, color='Black', lw=lw, alpha=alpha)

    # select subplot
    if USA:
        axis.set_xlim([-127.5, -64])
        axis.set_ylim([23, 50])
    else:

        axis.set_xlim([-180.5, -50])
        axis.set_ylim([11, 75])

def prepare_gdf(df):
    df = df.merge(right=df_air.add_suffix("_origin"), left_on="Origin", right_on="iata_origin")
    df = df.merge(right=df_air.add_suffix("_dest"), left_on="Dest", right_on="iata_dest")
    df['geometry'] = df.apply(
        lambda x: geom.LineString([(x['long_origin'], x['lat_origin']), (x['long_dest'], x['lat_dest'])]), axis=1)
    df = geopandas.GeoDataFrame(df, geometry=df['geometry'])
    return df

import matplotlib
matplotlib.use('TkAgg')


# find unique carrier

# take 3 most popular carriers
most_car = df.groupby(by="UniqueCarrier").size().sort_values().tail(3)
plot_(gdf[gdf.UniqueCarrier == most_car.index[0]], lw=0.2, alpha=0.01)

plt.axis('off')
axis.set_xlim([-127.5, -64])
axis.set_ylim([23, 50])

plt.savefig('png/OO_flights.png', dpi=1200)
plt.close()

plot_(gdf[gdf.UniqueCarrier == most_car.index[1]], lw=0.2, alpha=0.01)

plt.axis('off')
plt.savefig('png/AA_flights.png',  dpi=1200)
plt.close()

plot_(gdf[gdf.UniqueCarrier == most_car.index[2]], lw=0.2, alpha=0.009)

plt.axis('off')
plt.savefig('png/WN_flights.png',  dpi=1200)
plt.close()

# take 3 least popular carriers
less_car = df.groupby(by="UniqueCarrier").size().sort_values().head(3)
plot_(gdf[gdf.UniqueCarrier == less_car.index[0]], lw=1, alpha=0.01, USA=False)

plt.axis('off')
plt.savefig('png/AQ_flights.png',  dpi=1200)
plt.close()

plot_(gdf[gdf.UniqueCarrier == less_car.index[1]], lw=1, alpha=0.01, USA=False)

plt.axis('off')
plt.savefig('png/HA_flights.png',  dpi=1200)
plt.close()

plot_(gdf[gdf.UniqueCarrier == less_car.index[2]], lw=1, alpha=0.009)

plt.axis('off')
plt.savefig('png/F9_flights.png',  dpi=1200)
plt.close()

# ploting least flights
least_flights = pd.read_csv('results/routes\origin_dest/last_1_yr_least_flights_od.csv')
least_flights = prepare_gdf(least_flights)
axis = states.plot(color='lightblue', edgecolor='black')


# plot airports
gdf_air[gdf_air.iata.isin(least_flights.Origin)].plot(ax=axis, color="red", markersize=25)
# plot flights
least_flights.plot(ax=axis, color='Black', lw=0.5, alpha=0.5)
axis.set_xlim([-127.5, -64])
axis.set_ylim([23, 50])
plt.axis('off')
plt.savefig('png/least__flights.png',  dpi=1200)
plt.close()


# most used flights
most_flights = pd.read_csv('results/routes\origin_dest/last_1_yr_most_flights_od.csv')
most_flights = prepare_gdf(most_flights)
axis = states.plot(color='lightblue', edgecolor='black')
# plot airports
gdf_air[gdf_air.iata.isin(most_flights.Origin)].plot(ax=axis, color="red", markersize=100)
# plot flights
most_flights.plot(ax=axis, color='Black', lw=2, alpha=1)
axis.set_xlim([-127.5, -64])
axis.set_ylim([23, 50])

plt.axis('off')
plt.savefig('png/most_used_flights.png',  dpi=1200)
plt.close()


# most popular airports

most_airports = pd.read_csv('results/activity\overall/last_3_yrs_most_pop_airports.csv')

most_airports = most_airports.merge(df_air, left_on="Airport", right_on="iata" )

axis = states.plot(color='lightblue', edgecolor='black')
most_airports = geopandas.GeoDataFrame(most_airports, geometry=most_airports['geometry'])

most_airports.Flights_norm = most_airports.Flights/1000000

most_airports.plot(ax=axis, color="red", markersize=most_airports.Flights_norm*40)

# axis.set_xlim([-127.5, -64])
# axis.set_ylim([23, 50])



# least popular airports
least_airports = pd.read_csv('results/activity\overall/last_3_yrs_least_pop_airports.csv')

least_airports = least_airports.merge(df_air, left_on="Airport", right_on="iata" )

#axis = states.plot(color='lightblue', edgecolor='black')
least_airports = geopandas.GeoDataFrame(least_airports, geometry=least_airports['geometry'])
least_airports.plot(ax=axis, color="yellow", markersize=10)

axis.set_xlim([-127.5, -64])
axis.set_ylim([23, 50])

plt.axis('off')
plt.savefig('png/most_popular_airports.png',  dpi=1200)
plt.close()

# most delay

most_airports_delay = pd.read_csv('results/delay/airports/last_3_yrs_most_delay_airports.csv')
least_airports = pd.read_csv('results/delay/airports/last_3_yrs_least_delay_airports.csv')

most_airports_delay = most_airports_delay.merge(df_air, left_on="Origin", right_on="iata" )
least_airports = least_airports.merge(df_air, left_on="Origin", right_on="iata" )


axis = states.plot(color='lightblue', edgecolor='black')
most_airports_delay = geopandas.GeoDataFrame(most_airports_delay, geometry=most_airports_delay['geometry'])
least_airports = geopandas.GeoDataFrame(least_airports, geometry=least_airports['geometry'])

most_airports_delay.Average_norm = most_airports_delay.Average/75
most_airports_delay.plot(ax=axis, color="red", markersize=most_airports_delay.Average_norm*100)
least_airports.plot(ax=axis, color="yellow", markersize=10)



axis.set_xlim([-127.5, -64])
axis.set_ylim([23, 50])

plt.axis('off')
plt.savefig('png/most_delay_airports.png',  dpi=1200)
plt.close()

# dep_time

dep_time = pd.read_csv("results/dep_time/last_3_yrs_dep_time_1hr_2.csv", sep=";")
dep_time.sort_values(by="Time")
plt.plot()