package model;

import java.math.BigDecimal;

public class OrderItem {
    private Long id;
    private Long orderId;
    private MenuItem menuItem;
    private Long menuItemId;
    private Integer quantity;
    private BigDecimal unitPrice;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public MenuItem getMenuItem() {
        return menuItem;
    }

    public void setMenuItem(MenuItem menuItem) {
        this.menuItem = menuItem;
    }

    public Long getMenuItemId() {
        if (menuItemId != null) {
            return menuItemId;
        } else if (menuItem != null) {
            return menuItem.getId();
        }
        return null;
    }

    public void setMenuItemId(Long menuItemId) {
        this.menuItemId = menuItemId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public void setUnitPrice(Double price) {
        this.unitPrice = price != null ? BigDecimal.valueOf(price) : null;
    }

    public BigDecimal getTotalPrice() {
        if (unitPrice != null && quantity != null) {
            return unitPrice.multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }

    public double getTotalPriceAsDouble() {
        return getTotalPrice().doubleValue();
    }
}