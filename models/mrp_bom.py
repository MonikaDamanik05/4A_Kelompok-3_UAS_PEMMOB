from odoo import models, fields, api

class MrpBom(models.Model):
    _inherit = 'mrp.bom'

    total_equipment_cost = fields.Float(
        string='Total Equipment Cost',
        compute='_compute_total_equipment_cost',
        help='Total equipment cost from all operations'
    )

    @api.depends('operation_ids.equipment_cost')
    def _compute_total_equipment_cost(self):
        for bom in self:
            bom.total_equipment_cost = sum(bom.operation_ids.mapped('equipment_cost'))

    def _get_bom_data(self, price, product_uom, bom=False):
        """Override untuk menambahkan equipment cost ke struktur biaya"""
        res = super(MrpBom, self)._get_bom_data(price, product_uom, bom)
        
        # Tambahkan equipment cost ke total
        if self.operation_ids:
            total_equipment_cost = sum(self.operation_ids.mapped('equipment_cost'))
            res['total'] += total_equipment_cost
            
            # Tambahkan detail equipment cost ke operations
            if 'operations' in res:
                for operation_data in res['operations']:
                    operation = self.env['mrp.routing.workcenter'].browse(operation_data['id'])
                    if operation.equipment_cost > 0:
                        operation_data['equipment_cost'] = operation.equipment_cost
        
        return res