package com.example.provider.graphql;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import com.example.provider.model.Product;
import com.example.provider.service.ProductService;

@Controller
public class ProductResolver {

	private final ProductService productService;

	public ProductResolver(ProductService productService) {
		this.productService = productService;
	}

	@QueryMapping
	public Product product(@Argument Integer id) {
		System.out.println("numid====>" + id);
		return productService.getProduct(id);
	}
}
