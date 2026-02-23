from flask import Flask
from prometheus_client import start_http_server, Counter

app = Flask(__name__)
ORDERS = Counter('app_orders_total', 'Total number of processed orders')

@app.route('/')
def process_order():
    ORDERS.inc()
    return "Order Processed Successfully!"

if __name__ == '__main__':
    start_http_server(8000)
    app.run(host='0.0.0.0', port=5000)
