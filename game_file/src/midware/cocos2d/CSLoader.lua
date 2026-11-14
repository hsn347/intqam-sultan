local CSLoader = class("CSLoader")
function CSLoader:getInstance()
	return self
end
function CSLoader:createTimeline(filepath)
	return cc.ActionTimeLine:create()
end
function CSLoader:createNode(filepath)
	return cc.uiloader:load(filepath)
end
return CSLoader
