local nebulaCompetitionCtrl = SoraDGetCtrl("nebulaCompetitionCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local NebulaKingMainItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaCompetition/NebulaKingMainItem", NebulaKingMainItem)
function NebulaKingMainItem:onInit()
	self.fields.Text_reach:setString(i18n("common_text_2210"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function NebulaKingMainItem:onItemRenderer(index, obj)
	local itemId = self.cfg.reward[index * 2 + 1]
	local itemNum = self.cfg.reward[index * 2 + 2]
	obj:initData(itemId, itemNum)
end
function NebulaKingMainItem:onShow()
end
function NebulaKingMainItem:initData(cfg, isGrayed)
	self.cfg = cfg
	local myScore = nebulaCompetitionCtrl:getMyScore()
	local score = cfg.task[1]
	self.fields.List_reward:setNumItems(#cfg.reward / 2)
	nebulaCompetitionCtrl = nil
	;(nil).task = string.formatnumberthousands(score)
	self.fields.Text_score:setString(i18n("Nebulaking_text_24", nil))
	self.controllers.c1:setSelectedIndex(myScore >= score and 1 or 0)
	if myScore >= score then
		self.controllers.c1:setSelectedIndex(1)
	else
		nebulaCompetitionCtrl = i18n("Nebulaking_text_24", nil)
		i18n("Nebulaking_text_24", nil).num = math.floor(100 * myScore / score)
		self.fields.Text_progress:setString(i18n("common_text_4424", i18n("Nebulaking_text_24", nil)))
		self.controllers.c1:setSelectedIndex(0)
	end
	if isGrayed then
		for i, v in ipairs(self:getChildren()) do
			if v ~= self.fields.Image_frame then
				v:setGrayed(true)
			end
		end
	end
end
return NebulaKingMainItem
