package model.Enums;

public enum OrderStatus {
    PENDING,
    CONFIRMED,
    PREPARING,
    READY,
    COMPLETED,
    CANCELLED;
    @Override
    public String toString() {
        return this.name();
    }
}
