from setuptools import setup

setup(
    name='blog',
    version='0.1',
    py_modules=['blog'],
    install_requires=[
        'Click',
    ],
    entry_points='''
        [console_scripts]
        blog=blog:cli
    ''',
)