from odoo import models, fields, api

class MrpRoutingWorkcenter(models.Model):
    _inherit = 'mrp.routing.workcenter'

    equipment_id = fields.Many2one(
        'mrp.equipment', 
        string='Equipment',
        help='Equipment used in this operation'
    )
    equipment_utilization = fields.Float(
        string='Equipment Utilization (%)',
        default=100.0,
        help='Percentage of equipment capacity used (0-100%)'
    )
    equipment_cost = fields.Float(
        string='Equipment Cost',
        compute='_compute_equipment_cost',
        store=True,
        help='Calculated equipment cost for this operation'
    )

    @api.depends('equipment_id', 'equipment_id.cost', 'equipment_utilization', 'time_cycle', 'bom_id.product_qty')
    def _compute_equipment_cost(self):
        for operation in self:
            if operation.equipment_id and operation.equipment_id.cost > 0:
                # Cost per Hour dari Equipment
                cost_per_hour = operation.equipment_id.cost
                
                # Durasi dalam jam (time_cycle dalam menit)
                duration_hours = operation.time_cycle / 60.0
                
                # Utilisasi dalam desimal (70% = 0.7)
                utilization = operation.equipment_utilization / 100.0
                
                # Quantity produk dari BoM
                product_qty = operation.bom_id.product_qty or 1.0
                
                # Formula: (Cost per Hour × Utilisasi × Duration) / Quantity
                operation.equipment_cost = (cost_per_hour * utilization * duration_hours) / product_qty
            else:
                operation.equipment_cost = 0.0

    @api.constrains('equipment_utilization')
    def _check_equipment_utilization(self):
        for record in self:
            if record.equipment_utilization < 0 or record.equipment_utilization > 100:
                raise models.ValidationError('Equipment Utilization must be between 0 and 100%')