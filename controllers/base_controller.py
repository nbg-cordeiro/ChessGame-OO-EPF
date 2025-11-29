from bottle import static_file

class BaseController:
    def __init__(self, app):
        self.app = app
        self._setup_base_routes()


    def _setup_base_routes(self):
        self.app.route('/', method='GET', callback=self.home_redirect)
        self.app.route('/helper', method=['GET'], callback=self.helper)
        self.app.route('/static/<filename:path>', callback=self.serve_static)


    def home_redirect(self):
        return self.redirect('/users')

    def helper(self):
        return self.render('helper-final')


    def serve_static(self, filename):
        return static_file(filename, root='./static')


    def render(self, template, **context):
        from bottle import template as render_template
        return render_template(template, **context)


    def redirect(self, path, code=302):
        from bottle import HTTPResponse, response as bottle_response
        try:
            bottle_response.status = code
            bottle_response.set_header('Location', path)
            return bottle_response
        except Exception as e:
            print(f"ERRO NO REDIRECT: {type(e).__name__} - {str(e)}")
            return HTTPResponse(
                body=f'<script>window.location.href="{path}";</script>',
                status=200,
                headers={'Content-Type': 'text/html'}
            )
