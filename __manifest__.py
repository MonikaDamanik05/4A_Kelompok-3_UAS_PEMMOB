{
    'name': 'Manufacturing Equipment',
    'version': '1.0',
    'category': 'Manufacturing',
    'summary': 'Manage Equipment in Manufacturing Module',
    'description': """
        Add Equipment menu in Manufacturing Configuration
        - Manage equipment with name, code, cost, capacity, efficiency
    """,
    'depends': ['mrp'],
    'data': [
        'security/ir.model.access.csv',
        'views/mrp_equipment_views.xml',
        'views/mrp_routing_workcenter_views.xml',
    ],
    'installable': True,
    'application': False,
    'auto_install': False,
}