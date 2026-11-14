local FaceTreasurePrice = class("faceTreasurePrice", function(target)
	if target == nil then
		return SoraDCreateBasePanel("faceTreasurePrice")
	end
	return target
end)
function FaceTreasurePrice:ctor()
	if btn then
		btn:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function FaceTreasurePrice:btnClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		print("btn click")
	end
end
return FaceTreasurePrice
