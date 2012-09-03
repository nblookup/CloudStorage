package cn.im47.cloud.storage.common.web.file;

import cn.im47.cloud.storage.common.entity.file.Node;
import cn.im47.cloud.storage.common.service.file.NodeManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 存储结点控制器
 * <p/>
 * User: baitao.jibt@gmail.com
 * Date: 12-7-16
 * Time: 下午10:54
 */
@Controller
@RequestMapping(value = "/node")
public class NodeController {

    private NodeManager nodeManager;

    private static final String APP_KEY = "";

    /**
     * 获得所有节点
     *
     * @return
     */
    @RequestMapping(value = "list", method = RequestMethod.GET)
    public String list(Model model) {
        model.addAttribute("nodes", nodeManager.getTree(APP_KEY));
        return "node/list";
    }

    /**
    /**
     * 跳转到添加分类页面
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "create")
    public String create(Model model) {
        model.addAttribute("node", new Node());
        return "node/edit";
    }

    /**
     * 保存分类信息
     *
     * @param model
     * @param node
     * @return
     */
    @RequestMapping(value = "save")
    public String save(Model model, Node node) {

        if (nodeManager.save(APP_KEY, node) > 0) {
            model.addAttribute("info", "添加分类成功");
        } else {
            model.addAttribute("error", "添加分类失败");
        }
        return "redirect:/node/getChildren";
    }

    /**
     * 删除分类
     *
     * @param model
     * @param id
     * @return
     */
    @RequestMapping(value = "delete/{id}", method = RequestMethod.GET)
    public String delete(Model model, @PathVariable("id") Long id) {
        if (nodeManager.delete(APP_KEY, id) > 0) {
            model.addAttribute("info", "删除文件成功");
        } else {
            model.addAttribute("error", "删除文件失败");
        }
        return "node/getChildren";
    }

    @Autowired
    public void setNodeManager(NodeManager nodeManager) {
        this.nodeManager = nodeManager;
    }

}
