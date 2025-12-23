CREATE TABLE [SalesLT].[ProductAttribute] (
    [ProductID]  INT                                          NOT NULL,
    [Attributes] XML(CONTENT [dbo].[ProductAttributesSchema]) NULL,
    CONSTRAINT [FK_ProductAttributes] FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID])
);

