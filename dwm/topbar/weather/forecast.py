# -*- coding: utf-8 -*-
from __future__ import print_function
import forecastio, datetime, collections, argparse, pickle, os, sys, contextlib, urllib2, json
from dateutil import tz

# syspip2 install python-forecastio

parser = argparse.ArgumentParser()
parser.add_argument('--place', required = True)
parser.add_argument('--api-key', required = True)
parser.add_argument('--cache-file', required = True)
parser_group_action = parser.add_mutually_exclusive_group(required = True)
parser_group_action.add_argument('--just-place', action = 'store_true')
parser_group_action.add_argument('--forecast', action = 'store_true')
parser_group_action.add_argument('--current', action = 'store_true')
args = parser.parse_args()

positions = {
    'vilnius': {'place': 'vilnius', 'lat': 54.638037, 'lng': 25.286558}
}

EPOCH = datetime.datetime.utcfromtimestamp(0).replace(tzinfo = tz.tzutc())

def epochTimeInS(date):
    return int((date - EPOCH).total_seconds())

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

cur_epoch_time = epochTimeInS(datetime.datetime.now(tz.tzutc()))
closest_forecast_diff, closest_forecast_data = min([(abs(epochTimeInS(item['time']) - cur_epoch_time), item) for item in sum([item[1] for item in grouped_data_items], [])])

if closest_forecast_diff > 2 * 60 * 60:
    print('?°', end = '')
    sys.exit(0)

if args.just_place:
    print('lat:{:.5f}, lng:{:.5f}, place:{}'.format(data['position']['lat'], data['position']['lng'], data['position']['place'].encode('utf-8')))
elif args.forecast:
    hi_color = '#D8599B'
    local_creation_time = utcToLocal(data['created'])
    print('^fg({}){} ({} {})^fg()'.format(
        hi_color,
        data['position']['place'].encode('utf-8'),
        local_creation_time.date(),
        local_creation_time.time().hour))

    for day_data in grouped_data_items:
        print('^fg({}){}^fg()'.format(hi_color, day_data[0]))
        for data in day_data[1]:
            print('{:2d}h {:2.0f}° - {}'.format(data['time'].hour, data['temp'], data['text'].lower()))
elif args.current:
    print('{} {:.0f}°'.format(data['position']['place'].encode('utf-8'), closest_forecast_data['temp']), end = '')
