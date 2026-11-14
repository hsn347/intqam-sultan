local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisPersonalRankNode = class("atlantisPersonalRankNode", function(target)
	target = include("atlantisKindomRankNode").new(target)
	return target
end)
function atlantisPersonalRankNode:ctor(properties)
	self.rankType = 1
	self.rankTop = 150
	self.textName:setString(i18n("common_text_264"))
	self.btnPlayer = SoraDGetChildByName(self, "Button_Jump_Player")
	self.btnPlayer:addTouchEventListener(handler(self, self.btnJumpMyPlayerClick))
end
function atlantisPersonalRankNode:requestMore(beginIndex)
	if not beginIndex and self.hasMore == false then
		self.labelNotice:setString(i18n("common_text_085"))
		return
	else
		local index = beginIndex or self.rankIndex + 1
		print("Request data!!!, index = ", index)
		self:showLoadingSprite()
		SoraDShowLoading(self)
		atlantisActivityCtrl:reqPersonRank(index, self.rankType)
	end
end
return atlantisPersonalRankNode
