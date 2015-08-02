# -*- coding: utf-8 -*-
import forecastio, datetime, collections, argparse, pickle, os, sys, contextlib, urllib2, json
from dateutil import tz
from __future__ import print_function

# syspip2 install python-forecastio

parser = argparse.ArgumentParser()
parser.add_argument('--place', required = True)
parser.add_argument('--api-key', required = True)
parser.add_argument('--cache-file', required = True)
parser.add_argument('--forecast', action = 'store_true')
args = parser.parse_args()

positions = {
    'vilnius': {'place': 'vilnius', 'lat': 54.638037, 'lng': 25.286558}
}

def utcToLocal(utc):
    return utc.replace(tzinfo = tz.tzutc()).astimezone(tz.tzlocal())

def getCurrentPosition():
    try:
        with contextlib.closing(urllib2.urlopen('http://ip-api.com/json')) as response:
            location = json.loads(response.read())
            return {
                'place': location['city'],
                'lat': location['lat'],
                'lng': location['lon']
            }
    except (urllib2.URLError, ValueError):
        print('Could not detect current position', file = sys.stderr)
        return None

data = None

if os.path.isfile(args.cache_file):
    with open(args.cache_file, 'rb') as fp_cache:
        data = pickle.load(fp_cache)

if not data or data['created'] + datetime.timedelta(hours = 2) < datetime.datetime.utcnow() or data['place_requested'] != args.place:
    try:
        position = getCurrentPosition() if args.place == 'detect' else positions[position]
        if position:
            forecast = forecastio.load_forecast(args.api_key, position['lat'], position['lng'], units = 'si').hourly()

            grouped_data = collections.defaultdict(list)
            for data in forecast.data:
                time = utcToLocal(data.time)
                grouped_data[time.date()].append({
                    'time': time,
                    'temp': data.temperature,
                    'text': data.summary,
                })

            for key in grouped_data.keys():
                grouped_data[key] = sorted(grouped_data[key], key = lambda x: x['time'])

            data = {
                'created': datetime.datetime.utcnow(),
                'place_requested': args.place,
                'position': position,
                'grouped_data': grouped_data
            }

            with open(args.cache_file, 'wb') as fp_cache:
                pickle.dump(data, fp_cache)
    except:
        pass

if not data:
    sys.exit(1)

grouped_data_items = sorted(data['grouped_data'].items())

if args.forecast:
    hi_color = '#D8599B'
    local_creation_time = utcToLocal(data['created'])
    print('^fg({}){} ({} {})^fg()'.format(
        hi_color,
        data['position']['place'],
        local_creation_time.date(),
        local_creation_time.time().hour))

    for day_data in grouped_data_items:
        print('^fg({}){}^fg()'.format(hi_color, day_data[0]))
        for data in day_data[1]:
            print('{:2d}h {:2.0f}° - {}'.format(data['time'].hour, data['temp'], data['text'].lower()))
else:
    print('{} {}°'.format(data['position']['place'], grouped_data_items[0][1][0]['temp']), end = '')
