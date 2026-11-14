local royalSummonsAwardItem = class("royalSummonsAwardItem", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("royalSummonsAwardItem")
	end
	if target ~= nil then
		local timerClass = include("commonItemAward")
		target = timerClass.new(target)
	end
	return target
end)
function royalSummonsAwardItem:ctor()
	self.Text_lv = SoraDGetChildByName(self, "Text_lv")
end
function royalSummonsAwardItem:initItem(data)
	_ENV = nil
	;(nil).lv = data.lv or 1
	self.Text_lv:setString(i18n("common_text_100", nil))
	self:initData(data.id, data.count)
	local royalSummonsCtrl = SoraDGetCtrl("royalSummonsCtrl")
	if royalSummonsCtrl:getClassType() == 1 then
		if royalSummonsCtrl:checkNeedShowHighLight(data.id) then
			royalSummonsCtrl:playCircleEffect(true, self)
		else
			royalSummonsCtrl:playCircleEffect(false, self)
		end
	end
end
return royalSummonsAwardItem
