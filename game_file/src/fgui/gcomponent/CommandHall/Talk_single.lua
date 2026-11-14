local chatFunctions = include("chatFunctions")
local baseComponent = require("fgui.base.baseComponent")
local Talk_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommandHall/Talk_single", Talk_single)
function Talk_single:onInit()
end
function Talk_single:onShow()
end
function Talk_single:initTalkData(data)
	local name = data.name
	local key1 = data.key1
	local person = data.person
	local head = data.head
	self.fields.Text_1:setString(i18n(key1))
	if person == 1 then
		self.fields.Text_name:setAlign(SoraDFLabelL())
		self.fields.Text_1:setAlign(SoraDFLabelL())
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_head:setHeadSprite()
		local nickName = chatFunctions:getSelfNickName()
		self.fields.Text_name:setString(nickName)
	else
		self.controllers.c1:setSelectedIndex(0)
		if head then
			self.fields.Com_head:setHeadSprite(head)
		end
		self.fields.Text_name:setString(i18n(name))
	end
	if person == 1 and SoraDFIsRA() or person ~= 1 and not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
		self.fields.Load_1:fix(true)
	end
end
return Talk_single
