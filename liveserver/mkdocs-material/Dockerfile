# Instead of reinventing the wheel, use our existing
# image instead
FROM madebythepinshub/mkdocs-material:latest

# Set working directory
WORKDIR /docs

# Expose MkDocs development server port
EXPOSE 8000

# Start development server by default
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
