from odoo import models, fields, api

class MrpEquipment(models.Model):
    _name = 'mrp.equipment'
    _description = 'Manufacturing Equipment'
    _order = 'name'

    name = fields.Char(string='Equipment Name', required=True, translate=True)
    code = fields.Char(string='Code', copy=False)
    active = fields.Boolean(default=True)
    cost = fields.Float(string='Cost per Hour', default=0.0, help='Cost per hour for using this equipment')
    capacity = fields.Float(string='Capacity', default=1.0, help='Number of operations this equipment can do in parallel')
    efficiency = fields.Float(string='Time Efficiency', default=100.0, help='Efficiency factor in percentage')
    notes = fields.Text(string='Notes')
    company_id = fields.Many2one('res.company', string='Company', default=lambda self: self.env.company)

    _sql_constraints = [
        ('code_uniq', 'unique(code, company_id)', 'The code must be unique per company!'),
    ]

    @api.constrains('efficiency')
    def _check_efficiency(self):
        for record in self:
            if record.efficiency <= 0:
                raise models.ValidationError('Efficiency must be greater than 0')

    @api.constrains('capacity')
    def _check_capacity(self):
        for record in self:
            if record.capacity <= 0:
                raise models.ValidationError('Capacity must be greater than 0')