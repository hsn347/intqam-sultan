local worldKingdomLvSingleScroll = class("worldKingdomLvSingleScroll", function(target)
	return target
end)
function worldKingdomLvSingleScroll:ctor()
end
function worldKingdomLvSingleScroll:init(tbl)
	self.allOcxs, _ENV, self.backupOcxs, _ENV = nil, nil, nil, nil
	self.itemCopy = tbl.ocx
	if not tbl.info then
		_ENV = tbl.info
	end
	self.scrollFactoryData, _ENV, self.scrollData = tbl.info, tbl.info, tbl.info
	self.scrollSize = self:getContentSize()
	self.itemSize = cc.size(280, 130)
	self:factoryInfoList()
	self:addEventListener(handler(self, self.scrollEventCallBack))
	function self.addEventListener(target, cb)
		target.scrollEventCb = cb
	end
end
function worldKingdomLvSingleScroll:reSetData(info)
